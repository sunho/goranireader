import * as React from 'react'
import { Navigator } from 'react-native-navigation';
import { View, Text, StyleSheet } from 'react-native';
import TextInput from '../components/TextInput';
import { normalize, colorPrimary, colorAccent, colorSecondText } from '../utils/StyleUtil';
import Button from '../components/Button';

interface Props {
  navigator: Navigator
}

class AuthScreen extends React.Component<Props> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    return (
      <View style={styles.container}>
        <View style={styles.box}>
          <Text style={styles.header}>고라니 리더</Text>
          <View style={styles.form}>
            <TextInput placeholder='아이디'/>
            <TextInput placeholder='비밀번호'/>
            <Button style={styles.confirm} title='로그인'></Button>
          </View>
        </View>
        <Button color={colorSecondText} outline={true} title='회원가입'></Button>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'space-around',
    paddingBottom: normalize(10),
    paddingTop: normalize(10),
    width: '100%',
    height: '100%'
  },
  box: {
    marginTop: normalize(50),
    alignItems: 'center',
    padding: normalize(10)
  },
  header: {
    fontSize: normalize(30),
    color: colorPrimary,
    fontWeight: '600'
  },
  form: {
    marginTop: normalize(60),
    width: normalize(250)
  },
  confirm: {
    marginTop: normalize(20),
  }
})

export default AuthScreen
