import React from "react";
import { useCommonStyle } from "../../style";
import { Container, Paper, Typography } from "@material-ui/core";
import MaterialTable from 'material-table';

const MissionPage: React.FC = () => {
  const commonStyles = useCommonStyle();
  const [state, setState] = React.useState({
    columns: [
    ],
    data: [
    ],
  });
  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Paper className={commonStyles.paper}>
        <Typography variant="h5" component="h3">
          Mission
        </Typography>
      </Paper>
    </Container>
  );
};

export default MissionPage;
