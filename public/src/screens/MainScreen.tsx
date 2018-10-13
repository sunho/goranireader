import * as React from 'react'
import { Navigator } from 'react-native-navigation';
import { View } from 'react-native';

interface Props {
  navigator: Navigator
}

class AuthScreen extends React.Component<Props> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    return (
      <View>
      </View>
    )
  }
}
