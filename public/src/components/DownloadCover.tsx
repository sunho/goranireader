import * as React from 'react'
import { View, Text, ScrollView, StyleSheet } from 'react-native';
import { colorSecondText, colorWhite, normalize, colorText } from '../utils/StyleUtil';

interface Props {
  percent: number
  style?: any
}

export default class DownloadCover extends React.Component<Props> {
  render() {
    const { style, percent } = this.props
    return (
      <View style={style}>
        <View style={styles.container}>
        {
          percent === 0 ? (
            <Text style={styles.text}>
              다운로드
            </Text>
          ) : (
            <Text>
              {percent}
            </Text>
          )
        }
        </View>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: `rgba(0,0,0,0.05)`,
    alignItems: 'center',
    justifyContent: 'center'
  },
  text: {
    color: colorText,
    fontSize: normalize(20),
  }
})
