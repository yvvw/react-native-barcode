# react-native-barcode

## 特性

- 高效准确识别各种类型的条形码，包括二维码、商品条形码等
- iOS 图片识别使用 [ZBar](http://zbar.sourceforge.net/) 、扫描识别使用 [AVFundation](https://developer.apple.com/av-foundation/)
- Android 图片识别使用 [ZBar](http://zbar.sourceforge.net/) & [ZXing](https://github.com/zxing/zxing)、扫描识别使用 [ZBar](http://zbar.sourceforge.net/)
- ZBar 源码是用 C 写的，执行效率高，识别速度快
- ZXing 识别速度稍慢，对模糊不清的图像数据识别率高

## 安装

```bash
yarn add @yyyyu/react-native-barcode
```

or

```bash
npm install --save @yyyyu/react-native-barcode
```

### ios

#### 1. 自动配置(推荐)

```bash
react-native link @yyyyu/react-native-barcode
```

如果项目**使用 Pods 管理依赖**需要在 Podfile 中添加

```ruby
pod 'React', :path => '../node_modules/react-native', :subspecs => ['Dependency']
pod 'yoga', :path => '../node_modules/react-native/ReactCommon/yoga'
```
#### 2. 手动配置

1. 使用 Xcode 打开项目，在项目依赖目录(Libraries)下添加 node_modules 中的 @yyyyu/react-native-barcode 项目
2. 在 Linked Frameworks and Libraries 添加 libiconv.tbd
3. ​在 Info.plist 文件添加相机使用权限 NSCameraUsageDescription

### android

#### 1. 自动配置(如果 IOS 已经运行过，不需要重复运行)

```bash
react-native link @yyyyu/react-native-barcode
```

#### 2. 手动配置

1. 在 android/settings.gradle 文件中添加

    ```Groovy
    include ':react-native-barcode'
    project(':react-native-barcode').projectDir = new File(rootProject.projectDir, '../node_modules/@yyyyu/react-native-barcode/android')
    ```

2. 在 android/app/build.gradle 文件中依赖部分添加

    ```Groovy
    dependencies {
        // other dependencies
        compile project(':react-native-barcode')
    }
    ```
  
3. 在 android/app/src/main/AndroidManifest.xml 文件中添加相机使用权限

    ```xml
    <uses-permission android:name="android.permission.CAMERA" />
    ```

4. 在 MainApplication.java 文件中添加

    ```Java
    import com.react.barcode.RCTBarcodePackage;

    @Override
    protected List<ReactPackage> getPackages() {
        return Arrays.<ReactPackage>asList(
            // other packages
            new RCTBarcodePackage()
        );
    }
    ```

## JS API

```javascript
import BarcodeScanView, { image, Format, ErrorCode, BarcodeError } from '@yyyyu/react-native-barcode'

const imageLocal = require('xxx/xxx/barcode.png')
const imageBase64 = 'xxxxxxxxxxxx'
const imageBase64WithMime = 'data:image/png;base64,xxxxxxxx'
const imageFileUri = 'file:///xxx/barcode.png'
const imageFilePath = '/xxx/barcode.png'
const imageLink = 'https://cdn.image.com/barcode.png'

(async function() {
  try {
    const { type, content } = await image(imageXxx, Format.QR_CODE)
    if (type === Format.QRCODE) {
      console.log('result: ' + content)
    }
  } catch (e) {
    if (e instanceof BarcodeError) {
      switch (e.code) {
        case ErrorCode.BARCODE_NOT_FOUND:
          console.log('not found barcode.')
          break
        default:
          console.log('other error occur.')
      }
    }
  }
})()


function ScanView() {
  const scanSize = 200
  return (
    <View style={{ flex: 1 }}>
      <BarcodeScanView
        formats={Format.QR_CODE}
        onScan={function handleScan({ type, content }) {
          if (type === Format.QR_CODE) {
            console.log('result: ' + content)
          }
        }}
        onError={function handleError(e) {
          if (e instanceof BarcodeError) {
            if (e.code === ErrorCode.NOT_GRANT_USE_CAMERA) {
              console.log('user not grant use camera.')
            } else if (e.code === ErrorCode.DEVICE_NO_CAMERA) {
              console.log('this device no camera.')
            }
          }
        }}
        scanSize={scanSize}
        style={{ width: '100%', height: '100%', backgroundColor: '#000' }}
      />
      <View 
        style={{ 
          position: 'absolute', 
          top: 0, 
          left: 0, 
          justifyContent: 'center', 
          alignItems: 'center', 
          width: "100%", 
          height: '100%' 
        }}>
          <View style={{ width: scanSize, height: scanSize, backgroundColor: '#f003' }} />
      </View>
    </View>
  )
}
```

### image

```javascript
image() image(true) // 使用全部可用格式检测当前屏幕中是否包含条形码
image(Format | Format[], true) // 使用规定个格式检测当前屏幕中是否包含条形码
image(string | number) // 使用全部可用格式检测图片中包含的条形码(包含各种形式的图片)
image(string | number, Format | Format[]) // 使用规定个格式检测当各种形式的图片是否包含条形码
```

### BarcodeScanView

```javascript
<BarcodeScanView
  enable={boolean} // 是否识别条形码 默认 true
  formats={Format | Format[]} // 扫描哪些格式的条形码 默认全部
  flash={boolean} // 是否闪光灯常亮 默认 false
  autoFocus={boolean} // 是否自动对焦 默认 true
  scanSize={number, { width: number, height: number }} // 识别区域 默认与显示区域相同
  onScan={function ({ type, content }) {}} // 扫描结果回调
  onError={function (e) {}} // 错误结果回调
/>
```

### FORMAT
```javascript
const Format = {
  // common
  CODE_39: 39, // Code 39 1D format.
  CODE_93: 93, // Code 93 1D format.
  CODE_128: 128, // Code 128 1D format.
  EAN_8: 8, // EAN-8
  EAN_13: 13, // EAN-13.
  PDF_417: 57, // PDF417 format.
  QR_CODE: 64, // QR Code 2D barcode format.
  UPC_E: 9, // UPC-E 1D format.
  // zbar special
  CODABAR: 38, // CODABAR 1D format.
  COMPOSITE: 15, // EAN/UPC composite iosOnly
  DATABAR: 34, // DataBar (RSS-14).
  DATABAR_EXP: 35, // DataBar Expanded.
  EAN_2: 2, // GS1 2-digit add-on iosOnly
  EAN_5: 5, // GS1 5-digit add-on iosOnly
  I_25: 25, // Interleaved 2 of 5.
  ISBN_10: 10, // ISBN-10 (from EAN-13)
  ISBN_13: 14, // ISBN-13 (from EAN-13).
  UPC_A: 12, // UPC-A 1D format.
  // zxing special
  AZTEC: 70, // Aztec 2D barcode format.
  CODABAR: 38, // CODABAR 1D format.
  DATA_MATRIX: 71, // Data Matrix 2D barcode format.
  ITF: 72, // ITF (Interleaved Two of Five) 1D format.
  MAXICODE: 73, // MaxiCode 2D barcode format.
  RSS_14: 74, // RSS 14
  RSS_EXPANDED: 75, // RSS EXPANDED
  UPC_A: 12, // UPC-A 1D format.
  UPC_EAN_EXTENSION: 76, // UPC/EAN extension format. Not a stand-alone format.
  // av fundation special
  AZTEC: 70, // Aztec codes
  CODE_39_MOD43: 77, // Code 39 mod 43
  DATA_MATRIX: 71, // DataMatrix
  ITF: 72, // Interleaved 2 of 5 codes
  ITF14: 78 // ITF14 codes
}
```

### ERROR CODE

```javascript
const ErrorCode = {
  BARCODE_NOT_FOUND: -1, // 未识别出条形码
  DECODE_FAILED: -2, // 解码失败(图片转换过程出错)
  FILE_NOT_FOUND: -3, // 文件未发现(传入图片路径未找到文件)
  NOT_GRANT_READ_IMAGE: -4, // 未授权读取图片
  NOT_GRANT_USE_CAMERA: -5, // 未授权使用相机
  DEVICE_NO_CAMERA: -6, // 设备没有摄像头
  ILLEGAL_PARAMETER: -9 // 非法参数
}
```
