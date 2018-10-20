import * as React from 'react'
import { View, Text, ScrollView, Image, StyleSheet } from 'react-native';
import { normalize, colorDivider, colorText, shadow, colorPrimary, colorWhite, colorLightPrimary, colorSecondText } from '../utils/StyleUtil';
import { Book, booksReducder } from '../store/books';

interface Props {
  book: Book
}

export default class BookItem extends React.Component<Props> {
  render() {
    const { name, author, cover } = this.props.book
    return (
      <View style={styles.container}>
        <Image style={styles.cover} source={{uri: cover}}/>
        <View style={styles.info}>
          <Text style={styles.name}>{name}</Text>
          <Text style={styles.author}>{author}</Text>
        </View>
      </View>
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
  author: {
    fontSize: normalize(15),
    fontWeight: '300'
  }
})
