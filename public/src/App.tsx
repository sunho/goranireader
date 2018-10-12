import * as React from 'react'
import {StyleSheet, Text, View} from 'react-native'
import locale from './locales'

const App: React.SFC = () => {
  return (
    <View style={styles.container}>
      <Text> { locale.asdf } </Text>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1
  }
})

export default App;
