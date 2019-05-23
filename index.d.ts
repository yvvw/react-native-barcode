import { Component } from 'react'

/** ************ Apis ************ **/
export interface IResult {
  type: number | number[],
  content: string
}

/**
 * universal image decoder
 */
export const image: (...args: unknown[]) => Promise<IResult>

/** ************ Component ************ **/
export interface IProps {
  enable: boolean, // enable detect barcode
  formats: number | number[], // barcode formats
  flash: boolean, // whether turn on camera flash
  autoFocus: boolean, // whether camera auto focus
  scanSize: { width: number, height: number } | number,
  onScan: (result: IResult) => {}, // scan callback
  onError: ({ code: number, message: string }) => {} // scan callback
}

export default class BarcodeScanView extends Component<IProps> { }

/** ************ Formats ************ **/
export enum Format {
  AZTEC = 70, // Aztec 2D barcode format.
  CODABAR = 38, // CODABAR 1D format.
  CODE_128 = 128, // Code 128 1D format.
  CODE_39 = 39, // Code 39 1D format.
  CODE_39_MOD43 = 77, // Code 39 mod 43
  CODE_93 = 93, // Code 93 1D format.
  COMPOSITE = 15, // EAN/UPC composite iosOnly
  DATABAR = 34, // DataBar (RSS-14).
  DATABAR_EXP = 35, // DataBar Expanded.
  DATA_MATRIX = 71, // Data Matrix 2D barcode format.
  EAN_13 = 13, // EAN-13.
  EAN_2 = 2, // GS1 2-digit add-on iosOnly
  EAN_5 = 5, // GS1 5-digit add-on iosOnly
  EAN_8 = 8, // EAN-8
  ISBN_10 = 10, // ISBN-10 (from EAN-13)
  ISBN_13 = 14, // ISBN-13 (from EAN-13).
  ITF = 72, // ITF (Interleaved Two of Five) 1D format.
  ITF14 = 78, // ITF14 codes
  I_25 = 25, // Interleaved 2 of 5.
  MAXICODE = 73, // MaxiCode 2D barcode format.
  PDF_417 = 57, // PDF417 format.
  QR_CODE = 64, // QR Code 2D barcode format.
  RSS_14 = 74, // RSS 14
  RSS_EXPANDED = 75, // RSS EXPANDED
  UPC_A = 12, // UPC-A 1D format.
  UPC_E = 9, // UPC-E 1D format.
  UPC_EAN_EXTENSION = 76 // UPC/EAN extension format. Not a stand-alone format.
}

export class BarcodeError extends Error {
  constructor(options: { code: number; message: string; });
  name: string;
  code: number;
  message: string;
}


