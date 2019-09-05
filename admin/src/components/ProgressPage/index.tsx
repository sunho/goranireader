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
  Button,
  AppBar,
  Tabs,
  InputLabel,
  Select,
  Tab,
  FormControl,
  MenuItem,
  FormHelperText
} from "@material-ui/core";
import { FirebaseContext } from "../Firebase";
import { Bar, ResponsiveBar, ResponsiveBarCanvas, BarCanvas } from "@nivo/bar";
import { ClasssContext, ClassInfo } from "../Auth/withClass";
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

enum TabState {
  Book = 0,
  Chapter,
  BookQuiz,
  ChapterQuiz
}

interface TabDef {
  minValue: number;
  maxValue: number;
  percent: boolean;
  getLabels?(data: UserInsight[], cals: ClassInfo): { name: string; value: any }[];
  getData(
    data: UserInsight[],
    clas: ClassInfo,
    label?: any
  ): { username: string; value: number }[];
}
const TabToTabDef: TabDef[] = [
  {
    minValue: 0,
    maxValue: 1,
    percent: true,
    getData: (data, clas, label) => {
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      return data.flatMap(user => {
        if (!user.bookReads) {
          return [];
        }
        const out = user.bookReads[clas.currentClass!.mission!.bookId!];
        if (!out) {
          return [];
        }
        return [{ username: user.username, value: out }];
      });
    }
  },
  {
    minValue: 0,
    maxValue: 1,
    percent: true,
    getLabels: (data, clas) => {
      const out = new Set<string>();
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      data.forEach(user => {
        if (!user.chapterReads) {
          return;
        }
        if (!user.chapterReads[clas.currentClass!.mission!.bookId!]) {
          return;
        }
        Object.keys(user.chapterReads[clas.currentClass!.mission!.bookId!]).forEach(key =>{
          out.add(key);
        });
      });
      return Array.from(out).map(item => ({name: item, value: item}));
    },
    getData: (data, clas, label) => {
      if (!label) {
        return [];
      }
      if (!clas.currentClass) {
        return [];
      }
      if (!clas.currentClass.mission) {
        return [];
      }
      if (!clas.currentClass.mission.bookId) {
        return [];
      }
      return data.flatMap(user => {
        if (!user.chapterReads) {
          return [];
        }
        if (!user.chapterReads[clas.currentClass!.mission!.bookId!]) {
          return [];
        }
        const out = user.chapterReads[clas.currentClass!.mission!.bookId!][label];
        if (!out) {
          return [];
        }
        return [{ username: user.username, value: out }];
      });
    }
  }
];

const ProgressPage: React.FC = () => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const commonStyles = useCommonStyle();
  const [tab, setTab] = useState(TabState.Book);
  const [raw, setRaw] = useState<UserInsight[]>([]);
  const [label, setLabel] = useState<number>(0);
  const tabDef = TabToTabDef[tab];
  const labels = tabDef.getLabels && tabDef.getLabels(raw, classInfo);
  const data = tabDef.getData(raw, classInfo, labels ? (labels[label] ? labels[label].value : undefined) : undefined);
  const classes = useStyles();
  useEffect(() => {
    (async () => {
      const res = await firebase.serverComputed(classInfo.currentId!).get();
      const out = await Promise.all(res.docs.map(async doc => {
        const useri = await firebase.user(doc.id).get();
        return { ...doc.data(), username: useri.data()!.username };
      }));
      console.log(out);
      setRaw(out as any);
    })();
  }, [classInfo]);

  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Typography variant="h5" component="h3">
        Progress
      </Typography>
      <AppBar position="static" color="default">
        <Tabs
          value={tab}
          onChange={(e, value) => {
            setTab(value);
          }}
          indicatorColor="primary"
          textColor="primary"
          variant="fullWidth"
          aria-label="full width tabs example"
        >
          <Tab label="Mission Book Read Progress"/>
          <Tab label="Mission Chapter Read Progress"/>
        </Tabs>
      </AppBar>
      <Card className={classes.card}>
        {labels && (
          <FormControl required>
            <InputLabel htmlFor="age-required">Age</InputLabel>
            <Select
              value={label || 0}
              onChange={(e) => {setLabel(e.target.value as any);}}
              inputProps={{
                id: "age-required"
              }}
            >
              {
                labels.map((label, i) => (
                  <MenuItem value={i}>{label.name}</MenuItem>
                ))
              }
            </Select>
            <FormHelperText>Required</FormHelperText>
          </FormControl>
        )}
        <div style={{ height: data.length * 50 + 100}}>
          <ResponsiveBarCanvas
            padding={0.15}
            margin={{ top: 50, right: 60, bottom: 50, left: 60 }}
            minValue={tabDef.minValue}
            maxValue={tabDef.maxValue}
            tooltip={tabDef.percent ? ({ id, value, color }) => (
              <strong>
                {id}: {Math.round(value*10000)/100}%
              </strong>
          ) : undefined}
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
            keys={["value"]}
          />
        </div>
      </Card>
    </Container>
  );
};

export default ProgressPage;
