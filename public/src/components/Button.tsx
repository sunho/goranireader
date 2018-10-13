import * as React from 'react'
import { Text, StyleSheet, View } from 'react-native'
import { normalize, colorDivider, colorSecondText, colorPrimary } from '../utils/StyleUtil';

interface Props {
  title: string
  color?: string
  fontSize?: number
  outline?: boolean
  style?: any
}

export default class Button extends React.Component<Props> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    const styles = createStyles(this.props.color ? this.props.color : colorPrimary)
    return (
      <View style={this.props.style}>
        <View style={[styles.container, this.props.outline ? styles.outline : {}]}>
          <Text style={[styles.text, this.props.outline ? styles.outlineText : {}]}>
            {this.props.title}
          </Text>
        </View>
      </View>
    )
  }
}

function createStyles(color: string) {
  return StyleSheet.create({
    container: {
      alignItems: 'center',
      backgroundColor: color,
      borderRadius: normalize(5),
      paddingLeft: normalize(40),
      paddingRight: normalize(40),
      paddingTop: normalize(13),
      paddingBottom: normalize(13),
      marginBottom: normalize(20)
    },
    outline: {
      backgroundColor: '#fff',
      borderColor: color,
      borderWidth: 1
    },
    text: {
      fontSize: normalize(20),
      color: '#fff'
    },
    outlineText: {
      color: color
    }
  })
}

