import * as React from 'react'
import { Text, StyleSheet, View, TouchableOpacity } from 'react-native'
import { normalize, shadow, colorPrimary } from '../utils/StyleUtil';

interface Props {
  title: string
  color?: string
  onPress?: () => void
  fontSize?: number
  outline?: boolean
  style?: any
}


export default class Button extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    const styles = createStyles(this.props.color || colorPrimary)
    return (
      <View style={this.props.style}>
        <TouchableOpacity activeOpacity = { 0.8 }>
          <View
            onTouchEnd={() =>  {
              this.props.onPress && this.props.onPress()
            }}
            style={[
              styles.container,
              this.props.outline && styles.outline
            ]}
          >
            <Text
              style={[
                styles.text,
                this.props.outline && styles.outlineText
              ]}
            >
              {this.props.title}
            </Text>
          </View>
        </TouchableOpacity>
      </View>
    )
  }
}

function createStyles(color: string) {
  return StyleSheet.create({
    container: {
      alignItems: 'center',
      backgroundColor: color,
      flexDirection: 'row',
      justifyContent: 'center',
      borderRadius: normalize(3),
      paddingLeft: normalize(40),
      paddingRight: normalize(40),
      height: normalize(45),
    },
    outline: {
      backgroundColor: 'rgba(0,0,0,0)',
      borderColor: color,
      borderWidth: normalize(1),
      shadowOpacity: 0
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

