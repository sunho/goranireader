import * as React from 'react'
import { View, Text, ScrollView, StyleSheet } from 'react-native';
import { normalize, colorDivider, colorText } from '../utils/StyleUtil';

interface Props {
  title: string
  children: any
}

export default class HeaderLayout extends React.Component<Props> {
  render() {
    return (
      <View style={styles.container}>
        <View style={styles.headerContainer}>
          <Text style={styles.headerText}>{this.props.title}</Text>
        </View>
        <View style={styles.contentContainer}>
          {this.props.children}
        </View>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: normalize(20)
  },
  headerContainer: {
    paddingTop: normalize(20),
    paddingBottom: normalize(10),
    paddingLeft: normalize(15),
    borderBottomColor: colorDivider,
    borderBottomWidth: normalize(1)
  },
  headerText: {
    fontSize: normalize(25),
    color: colorText,
    fontWeight: '200'
  },
  contentContainer: {
    flex: 1
  }
})
