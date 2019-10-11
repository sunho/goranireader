import React, { useState, useEffect, useContext } from "react";
import { useCommonStyle } from "../../style";
import {
  Container,
  Paper,
  Typography,
  ListItem,
  List,
  ListItemAvatar,
  Avatar,
  ListItemText
} from "@material-ui/core";
import FolderIcon from "@material-ui/icons/Folder";
import { Report } from "../../model";
import { FirebaseContext } from "../Firebase";
import { ClasssContext } from "../Auth/withClass";

const FindBookPage: React.FC = () => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const [reports, setReports] = useState<Report[]>([]);
  const commonStyles = useCommonStyle();
  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Typography variant="h5" className={commonStyles.header} component="h3">
        Find Book
      </Typography>
      <Paper className={commonStyles.paper}>
        <List>
        </List>
      </Paper>
    </Container>
  );
};

export default FindBookPage;
