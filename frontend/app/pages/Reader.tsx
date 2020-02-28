import * as React from 'react';
import { StyleSheet, View, Text, SafeAreaView, ScrollView, ListView } from "react-native";

const Reader = () => {

  return (
    <SafeAreaView style={styles.container}>
      <ListView
        dataSource={dataSource}
        renderRow={(rowData) => <Text>{rowData}</Text>}
      />
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


export default Reader;
