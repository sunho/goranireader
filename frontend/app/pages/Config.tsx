import * as React from 'react';
import { StyleSheet, View, Text, SafeAreaView, ScrollView } from "react-native";

const Config = () => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <Text>
          Hello world.
        </Text>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});


export default Config;
