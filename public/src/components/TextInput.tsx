import * as React from 'react'
import { TextInput as RTextInput, StyleSheet, View } from 'react-native'
import { normalize, colorDivider, colorSecondText } from '../utils/StyleUtil';

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
        />
      </View>
    )
  }
}

const styles = StyleSheet.create({
  input: {
    color: colorSecondText,
    borderBottomWidth: normalize(1),
    borderBottomColor: colorDivider,
    fontSize: normalize(20),
    height: normalize(40),
    marginBottom: normalize(30),
  }
})
