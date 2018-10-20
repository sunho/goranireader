import * as React from 'react'
import { TextInput as RTextInput, StyleSheet, View } from 'react-native'
import { normalize, colorDivider, colorSecondText, colorPrimary, colorText, colorWhite, colorLightPrimary } from '../utils/StyleUtil';

interface Props {
  placeholder?: string
  fontSize?: number
  style?: any
}

export default class TextInput extends React.Component<Props> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    return (
      <View style={this.props.style}>
        <RTextInput
          style={[styles.input, this.props.fontSize ? {fontSize: normalize(this.props.fontSize)} : {}]}
          placeholder={this.props.placeholder}
          placeholderTextColor={colorDivider}
        />
      </View>
    )
  }
}

const styles = StyleSheet.create({
  input: {
    color: colorSecondText,
    backgroundColor: colorLightPrimary,
    borderRadius: normalize(3),
    paddingLeft: normalize(10),
    paddingRight: normalize(10),
    fontSize: normalize(20),
    height: normalize(45),
    marginBottom: normalize(20),
  }
})
