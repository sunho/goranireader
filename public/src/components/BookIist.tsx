import * as React from 'react'
import { View, Text, ScrollView, Image, StyleSheet, TouchableOpacity } from 'react-native';
import { normalize, colorDivider, colorText, shadow, colorPrimary, colorWhite, colorLightPrimary, colorSecondText } from '../utils/StyleUtil';
import { Book, booksReducder } from '../store/books';
import DownloadCover from './DownloadCover';


export default class BookList extends React.Component<Props> {
  render() {
    const { name, author, cover, path } = this.props.book
    const { onPress } = this.props
    return (
      <TouchableOpacity onPress={onPress && onPress} activeOpacity = { 0.8 }>
        <View style={styles.container}>
          { !path && (<DownloadCover style={styles.downCover} percent={0}></DownloadCover>) }
          <Image style={styles.cover} source={{uri: cover}}/>
          <View style={styles.info}>
            <Text style={styles.name}>{name}</Text>
            <Text style={styles.author}>{author}</Text>
          </View>
        </View>
      </TouchableOpacity>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    marginHorizontal: normalize(12),
    borderRadius: normalize(5),
    marginTop: normalize(12),
    padding: normalize(10),
    backgroundColor: colorWhite,
    alignSelf: 'stretch',
    flexDirection: 'row',
    ...shadow(colorDivider)
  },
  cover: {
    width: normalize(60),
    height: normalize(80),
    resizeMode: 'center'
  },
  info: {
    marginLeft: normalize(10)
  },
  name: {
    fontSize: normalize(20),
    fontWeight: '600'
  },
  downCover: {
    position: 'absolute',
    left: 0,
    bottom: 0,
    top: 0,
    right: 0,
    zIndex: 2,
  },
  author: {
    fontSize: normalize(15),
    fontWeight: '300'
  }
})
