import * as React from 'react'
import { Navigator } from 'react-native-navigation';
import { View, Text, StyleSheet, KeyboardAvoidingView, ScrollView } from 'react-native';
import { normalize, colorLightPrimary } from '../utils/StyleUtil';
import HeaderLayout from '../components/HeaderLayout';
import BookItem from '../components/DownBooksList';
import { Book } from '../store/books';
import { ApplicationState } from '../store';
import { connect } from 'react-redux';
import Button from '../components/Button';

interface Props {
  navigator: Navigator
  book: Book
}

interface State {
}

class StoreDetailScreen extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    const { book } = this.props
    return (
      <View>
        <Text>{book.name}</Text>
        <Button onPress={()=>{
        }} title='다운로드'></Button>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colorLightPrimary
  }
})

const mapStateToProps = (state: ApplicationState) => (
  {
  }
)

export default connect(mapStateToProps)(StoreDetailScreen)
