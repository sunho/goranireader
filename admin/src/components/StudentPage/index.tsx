import React from "react";
import { Container, Paper, Typography } from "@material-ui/core";
import { useCommonStyle } from "../../style";
import Layout from "../Layout";

const StudentPage: React.FC = () => {
  const commonStyles = useCommonStyle();
  return (
    <Layout>
      <Container maxWidth="lg" className={commonStyles.container}>
        <Paper className={commonStyles.paper}>
          <Typography variant="h5" component="h3">
            Student
          </Typography>
        </Paper>
      </Container>
    </Layout>
  );
};

export default StudentPage;
