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

const ReportPage: React.FC = () => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const [reports, setReports] = useState<Report[]>([]);
  useEffect(() => {
    (async () => {
      const res = await firebase.reports(classInfo.currentId!).get();
      setReports(res.docs.map(doc => doc.data()) as any);
      // setReports([{
      //   name: "2019-09-06 Vocab ",
      //   link: "https://storage.cloud.google.com/gorani-reader-reports/asdf.csv",
      //   time: "asdf"
      // }]);
    })();
  }, [classInfo]);
  const commonStyles = useCommonStyle();
  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Typography variant="h5" className={commonStyles.header} component="h3">
        Report
      </Typography>
      <Paper className={commonStyles.paper}>
        <List>
          {reports.map(report => (
            <ListItem button component="a" href={report.link}>
              <ListItemAvatar>
                <Avatar>
                  <FolderIcon />
                </Avatar>
              </ListItemAvatar>
              <ListItemText primary={report.name} secondary={report.time} />
            </ListItem>
          ))}
          {
            reports.length === 0 && <div>couldn't find one :(</div>
          }
        </List>
      </Paper>
    </Container>
  );
};

export default ReportPage;
