import React from "react";
import { useCommonStyle } from "../../style";
import { Container, Paper, Typography } from "@material-ui/core";

const ProgressPage: React.FC = () => {
  const commonStyles = useCommonStyle();
  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Paper className={commonStyles.paper}>
        <Typography variant="h5" component="h3">
          Progress
        </Typography>
      </Paper>
    </Container>
  );
};

export default ProgressPage;