import React, { useContext, useState, useEffect } from "react";
import { useCommonStyle } from "../../style";
import {
  Container,
  Paper,
  Typography,
  makeStyles,
  Card,
  CardContent,
  CardActions,
  Button
} from "@material-ui/core";
import { FirebaseContext } from "../Firebase";
import { Bar, ResponsiveBar, ResponsiveBarCanvas, BarCanvas } from "@nivo/bar";
import { ClasssContext } from "../Auth/withClass";
import { UserInsight } from "../../model";
const useStyles = makeStyles({
  card: {
    minWidth: 275,
    padding: 20
  },
  bullet: {
    display: "inline-block",
    margin: "0 2px",
    transform: "scale(0.8)"
  },
  title: {
    fontSize: 14
  },
  pos: {
    marginBottom: 12
  }
});

enum View {

};

const ProgressPage: React.FC = () => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const commonStyles = useCommonStyle();
  const [selected, setSelected] = useState("");
  const [data, setData] = useState<UserInsight[]>([]);
  const classes = useStyles();
  useEffect(() => {
    (async () => {
      const res = await firebase.clientComputed(classInfo.currentId!).get();
      const mission = classInfo.currentClass!.mission;
      const bookId = mission ? (mission.bookId ? mission.bookId : null) : null;
      const clients = res.docs.map(it => {
        const clientBookReads = it.data().clientBookRead;
        let clientBookRead;
        if (bookId && clientBookReads && clientBookReads[bookId]) {
          clientBookRead = clientBookReads[bookId];
        }
        return { ...it.data(), id: it.id, clientBookRead: clientBookRead || 0 };
      });
      setData(clients as any);
    })();
  }, [classInfo]);

  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Typography variant="h5" component="h3">
        Progress
      </Typography>
      <Card className={classes.card} style={{height: data.length * 100}}>
        <ResponsiveBarCanvas
          padding={0.15}
          margin={{ top: 50, right: 60, bottom: 50, left: 60 }}
          maxValue={1}
          data={data}
          axisLeft={{
            tickSize: 5,
            tickPadding: 5,
            tickRotation: 0,
            legend: "",
            legendOffset: 36
          }}
          layout="horizontal"
          axisBottom={null}
          indexBy="username"
          keys={["clientBookRead"]}
        />
      </Card>
    </Container>
  );
};

export default ProgressPage;
