import * as React from 'react'
import { Navigator } from 'react-native-navigation';
import { View, Text, StyleSheet, KeyboardAvoidingView } from 'react-native';
import TextInput from '../components/TextInput';
import { normalize, colorPrimary, colorAccent, colorSecondText, colorLightPrimary, colorWhite, colorDivider, colorText } from '../utils/StyleUtil';
import Button from '../components/Button';

interface Props {
  navigator: Navigator
}

class LoginScreen extends React.Component<Props> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    return (
      <View style={styles.container}>
        <KeyboardAvoidingView behavior='position' contentContainerStyle={styles.formInside} style={styles.form} enabled>
          <Text style={styles.header}>고라니 리더</Text>
          <View style={styles.box}>
            <TextInput placeholder='아이디'/>
            <TextInput placeholder='비밀번호'/>
            <Button onPress={() => {console.error('asdfadsf')}} title='로그인'></Button>
          </View>
          <Text style={styles.register}>계정이 없으시다면 <Text style={styles.registerText}>회원가입</Text>을 해주세요.</Text>
        </KeyboardAvoidingView>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: colorLightPrimary,
    alignItems: 'center',
    paddingTop: normalize(50),
    paddingBottom: normalize(50),
    flex: 1
  },
  form: {
    marginTop: normalize(50),
    alignSelf: 'stretch'
  },
  formInside: {
    alignSelf: 'stretch',
    alignItems: 'center',
    paddingBottom: normalize(40)
  },
  box: {
    alignSelf: 'stretch',
    padding: normalize(25),
    marginTop: normalize(15),
    marginLeft: normalize(30),
    marginRight: normalize(30)
  },
  header: {
    fontSize: normalize(35),
    color: colorPrimary,
    fontWeight: '600',
  },
  register: {
    color: colorText,
    marginTop: normalize(5),
    fontSize: normalize(15),
    fontWeight: '300'
  },
  registerText: {
    color: colorAccent,
    fontWeight: '600'
  }
})

export default LoginScreen
