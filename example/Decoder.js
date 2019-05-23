import React, { Component } from "react";
import { Image, View, Button, Alert, StyleSheet } from "react-native";
import * as RNLBarCode from "@yyyyu/react-native-barcode";
import IMAGES from "./images";

export default class App extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Image source={IMAGES.EAN_13} />
        <Button title="Decode Image" onPress={this.decode} />
        <Button title="Scan Screen" onPress={this.screenshot} />
      </View>
    );
  }

  decode = async () => {
    try {
      const result = await RNLBarCode.decode({
        data: IMAGES.QR_CODE,
        formats: RNLBarCode.Type.Common.QR_CODE,
        decoder: RNLBarCode.Decoder.Auto
      });
      this.handleResult(result);
    } catch (e) {
      Alert.alert(RNLBarCode.Errors[error.code], error.message, [
        { text: "Ok" }
      ]);
    }
  };

  screenshot = async () => {
    try {
      const result = await RNLBarCode.decode({
        formats: RNLBarCode.Type.Common.EAN_13,
        decoder: RNLBarCode.Decoder.Auto,
        screenshot: true
      });
      this.handleResult(result);
    } catch (e) {
      Alert.alert(RNLBarCode.Errors[error.code], error.message, [
        { text: "Ok" }
      ]);
    }
  };

  handleResult = result => {
    if (result != null) {
      Alert.alert(
        "Success!",
        `format: ${RNLBarCode.Type.Common[result.format]}, content: ${
          result.content
        }`,
        [{ text: "Ok" }]
      );
    } else {
      console.log("not found");
      Alert.alert("Not Found", null, [{ text: "Ok" }]);
    }
  };
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#fff"
  }
});
