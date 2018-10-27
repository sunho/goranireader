import * as React from 'react'
import { Navigator } from 'react-native-navigation';
import { View, Text, StyleSheet, KeyboardAvoidingView, ScrollView } from 'react-native';
import { normalize, colorLightPrimary } from '../utils/StyleUtil';
import HeaderLayout from '../components/HeaderLayout';
import DownBooksList from '../components/DownBooksList'
import { Book } from '../store/books';
import { ApplicationState } from '../store';
import { connect } from 'react-redux';

interface Props {
  navigator: Navigator
  books: Book[]
}

export default class DownBooksListScreen extends React.Component<Props> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    const { navigator, books } = this.props
    return (
      <HeaderLayout title='책'>
        <View style={styles.container}>
          <DownBooksList navigator={navigator}/>
        </View>
      </HeaderLayout>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colorLightPrimary
  }
})
