import React, { Component } from 'react'
import { Image, Platform, PermissionsAndroid, NativeModules, requireNativeComponent } from 'react-native'

/** ************ Apis ************ **/
const { Barcode } = NativeModules

type FORMAT = number | number[]
type RESULT = { type: FORMAT, content: string }

/**
 * universal image decoder
 */
export const image = async function (...args) {
  switch (args.length) {
    case 0:
      return imageFactory(null, null, true)
    case 1:
      if (typeof args[0] === 'boolean') {
        return imageFactory(null, null, true)
      } else {
        return imageFactory(args[0])
      }
    case 2:
      if (typeof args[1] === 'boolean') {
        return imageFactory(null, args[0], true)
      } else {
        return imageFactory(args[0], args[1])
      }
    default:
      return imageFactory(...args)
  }
}

const imageFactory = async function (image: number | string, formats: FORMAT, screenshot: boolean): RESULT {
  let promise = null
  formats = parseFormats(formats)
  if (screenshot) {
    promise = Barcode.screenshot(formats)
  }
  if (typeof image === 'number') {
    // local file system image
    const source = Image.resolveAssetSource(image)
    if (!(source != null && source.__packager_asset)) {
      throw new BarcodeError(Error.FILE_NOT_FOUND, 'Image resource not found.')
    }
    promise = Barcode.image(source.uri, formats)
  } else if (typeof image === 'string') {
    if (
      /^(https?|file):\/{2}/.test(image) ||
      (image.indexOf('/') === 0 && image.indexOf('.') > 0)
    ) {
      // image url or path
      promise = Barcode.image(image, formats)
    } else {
      // base64 data
      const data = parseBase64(image)
      if (data !== null) promise = Barcode.base64(data, formats)
    }
  }
  if (promise === null) {
    throw new BarcodeError(ErrorCode.ILLEGAL_PARAMETER, 'Unknow image.')
  }
  try {
    return await promise
  } catch (e) {
    throw new BarcodeError(parseInt(e.code), e.message)
  }
}

/** ************ Component ************ **/
const RCTBarcodeScanView = requireNativeComponent('RCTBarcodeScanView')

type Props = {
  enable: boolean, // enable detect barcode
  formats: FORMAT, // barcode formats
  flash: boolean, // whether turn on camera flash
  autoFocus: boolean, // whether camera auto focus
  scanSize: { width: number, height: number } | number,
  onScan: (RESULT) => {}, // scan callback
  onError: ({ code: number, message: string }) => {} // scan callback
}

export default class BarcodeScanView extends Component<Props> {
  static DEFAULT_VALUE = -1

  state = {
    granted: false
  }

  componentDidMount () {
    if (Platform.OS === 'android') {
      this._configAndroidPermission()
    }
  }

  _configAndroidPermission = async () => {
    if (await PermissionsAndroid.check(PermissionsAndroid.PERMISSIONS.CAMERA)) {
      this.setState({ granted: true })
      return
    } else {
      const granted = await PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.CAMERA)
      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        this.setState({ granted: true })
        return
      }
    }
    this._onError({
      nativeEvent: {
        code: ErrorCode.NOT_GRANT_USE_CAMERA,
        message: 'User no authorize use camera.' }
    })
  }

  _parseProps = function (props) {
    const { enable, formats, flash, autoFocus, scanSize, ...rest } = props

    const mScanSize = {}
    if (typeof scanSize === 'object') {
      mScanSize.width = typeof scanSize.width === 'number'
        ? Math.max(scanSize.width, 0)
        : BarcodeScanView.DEFAULT_VALUE
      mScanSize.height = typeof scanSize.height === 'number'
        ? Math.max(scanSize.height, 0)
        : BarcodeScanView.DEFAULT_VALUE
    } else if (typeof scanSize === 'number' && scanSize >= 0) {
      mScanSize.width = scanSize
      mScanSize.height = scanSize
    } else {
      mScanSize.width = BarcodeScanView.DEFAULT_VALUE
      mScanSize.height = BarcodeScanView.DEFAULT_VALUE
    }

    return {
      ...rest,
      enable: (typeof enable === 'boolean') ? enable : true,
      formats: parseFormats(formats),
      flash: (typeof flash === 'boolean') ? flash : false,
      autoFocus: (typeof autoFocus === 'boolean') ? autoFocus : true,
      scanSize: mScanSize
    }
  }

  _onScan = ({ nativeEvent }) => {
    const { onScan } = this.props
    if (typeof onScan === 'function') {
      onScan(nativeEvent)
    }
  }

  _onError = ({ nativeEvent }) => {
    const { onError } = this.props
    if (typeof onError === 'function') {
      onError(new BarcodeError(nativeEvent.code, nativeEvent.message))
    }
  }

  render () {
    const { granted } = this.state
    const props = this._parseProps(this.props)

    return (
      <RCTBarcodeScanView
        {...props}
        granted={granted}
        onScan={this._onScan}
        onError={this._onError} />
    )
  }
}

/** ************ Formats ************ **/
const CommonFormat = {
  CODE_39: 39, // Code 39 1D format.
  CODE_93: 93, // Code 93 1D format.
  CODE_128: 128, // Code 128 1D format.
  EAN_8: 8, // EAN-8
  EAN_13: 13, // EAN-13.
  PDF_417: 57, // PDF417 format.
  QR_CODE: 64, // QR Code 2D barcode format.
  UPC_E: 9 // UPC-E 1D format.
}

const ZBarSpecialFormat = {
  CODABAR: 38, // CODABAR 1D format.
  COMPOSITE: 15, // EAN/UPC composite iosOnly
  DATABAR: 34, // DataBar (RSS-14).
  DATABAR_EXP: 35, // DataBar Expanded.
  EAN_2: 2, // GS1 2-digit add-on iosOnly
  EAN_5: 5, // GS1 5-digit add-on iosOnly
  I_25: 25, // Interleaved 2 of 5.
  ISBN_10: 10, // ISBN-10 (from EAN-13)
  ISBN_13: 14, // ISBN-13 (from EAN-13).
  UPC_A: 12 // UPC-A 1D format.
}

const ZXingSpecialFormat = {
  AZTEC: 70, // Aztec 2D barcode format.
  CODABAR: 38, // CODABAR 1D format.
  DATA_MATRIX: 71, // Data Matrix 2D barcode format.
  ITF: 72, // ITF (Interleaved Two of Five) 1D format.
  MAXICODE: 73, // MaxiCode 2D barcode format.
  RSS_14: 74, // RSS 14
  RSS_EXPANDED: 75, // RSS EXPANDED
  UPC_A: 12, // UPC-A 1D format.
  UPC_EAN_EXTENSION: 76 // UPC/EAN extension format. Not a stand-alone format.
}

const AVFundationSpecialFormat = {
  AZTEC: 70, // Aztec codes
  CODE_39_MOD43: 77, // Code 39 mod 43
  DATA_MATRIX: 71, // DataMatrix
  ITF: 72, // Interleaved 2 of 5 codes
  ITF14: 78 // ITF14 codes
}

export const Format = {
  ...CommonFormat,
  ...ZBarSpecialFormat,
  ...ZXingSpecialFormat,
  ...AVFundationSpecialFormat
}

/** ************ Error ************ **/
export const ErrorCode = {
  BARCODE_NOT_FOUND: -1, // 未识别出条形码
  DECODE_FAILED: -2, // 解码失败(图片转换过程出错)
  FILE_NOT_FOUND: -3, // 文件未发现(传入图片路径未找到文件)
  NOT_GRANT_READ_IMAGE: -4, // 未授权读取图片
  NOT_GRANT_USE_CAMERA: -5, // 未授权使用相机
  DEVICE_NO_CAMERA: -6, // 设备没有摄像头
  ILLEGAL_PARAMETER: -9 // 非法参数
}

export class BarcodeError extends Error {
  constructor (code, message) {
    super(message)

    this.name = 'BarcodeError'
    this.code = code
    this.message = message

    if (typeof Object.setPrototypeOf === 'function') {
      Object.setPrototypeOf(this, BarcodeError.prototype)
    } else {
      this.__proto__ = BarcodeError.prototype // eslint-disable-line
    }
  }
}

/** ************ Ohter ************ **/
const parseFormats = function (formats: any): FORMAT {
  if (typeof formats === 'number') {
    const formatList = [formats]
    if (formatList.indexOf(formats) > -1) return [formats]
  } else if (Array.isArray(formats)) {
    const formatList = Object.values(Format)
    for (let i = 0; i < formats.length; i++) {
      if (formatList.indexOf(formats[i]) === -1) {
        formats.splice(i, 1)
      }
    }
    return formats
  }
  return Object.values(Format)
}

const parseBase64 = function (data: string): ?string {
  data = data.split(',').length === 2 ? data.split(',')[1] : data
  try {
    // eslint-disable-next-line
    if (btoa(atob(data)) === data) return data
  } catch (e) {
    return null
  }
}
