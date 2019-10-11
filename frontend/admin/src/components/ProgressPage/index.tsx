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
import { Bar, ResponsiveBar, ResponsiveBarCanvas, BarCanvas, BarItemProps, BarExtendedDatum } from "@nivo/bar";
import { ClasssContext, ClassInfo } from "../Auth/withClass";
import { UserInsight } from "../../model";
import { TabToTabDef, msToString } from "./tabs";
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

const ProgressPage: React.FC = () => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const commonStyles = useCommonStyle();
  const [tab, setTab] = useState(0);
  const [raw, setRaw] = useState<UserInsight[]>([]);
  const [label, setLabel] = useState<number>(0);
  const tabDef = TabToTabDef[tab];
  const labels = tabDef.getLabels && tabDef.getLabels(raw, classInfo);
  const data = tabDef.getData(
    raw,
    classInfo,
    labels ? (labels[label] ? labels[label].value : undefined) : undefined
  );
  console.log(data);
  const classes = useStyles();
  useEffect(() => {
    (async () => {
      const res = await firebase.serverComputed(classInfo.currentId!).get();
      const out = await Promise.all(
        res.docs.map(async doc => {
          const useri = await firebase.user(doc.id).get();
          return { ...doc.data(), username: useri.data()!.username };
        })
      );
      console.log(out);
      setRaw(out as any);
    })();
  }, [classInfo]);

  const defFunc: React.FC<BarExtendedDatum> = (() => {
    if (tabDef.type === "percent") {
      return (props: BarExtendedDatum) => (
        <strong>
          {props.id}: {Math.round(props.value * 10000) / 100}%
        </strong>
      );
    } else if (tabDef.type === "days") {
      return (props: BarExtendedDatum) => (
        <strong>
          {props.id}: {msToString(props.value)}
        </strong>
      );
    } else {
      return (props: BarExtendedDatum) => (
        <strong>
          {props.data.id}: {props.data.value}
        </strong>
      );
    }
  })();

  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Typography variant="h5" component="h3" className={commonStyles.header}>
        Progress
      </Typography>
      <AppBar position="static" color="default">
        <Tabs
          value={tab}
          onChange={(e, value) => {
            setTab(value);
          }}
          variant="scrollable"
          scrollButtons="auto"
          indicatorColor="primary"
          textColor="primary"
          aria-label="full width tabs example"
        >
          <Tab label="Book Read Progress" />
          <Tab label="Chapter Read Progress" />
          <Tab label="Book Read Time" />
          <Tab label="Chapter Read Time" />
        </Tabs>
      </AppBar>
      <Card className={classes.card}>
        {labels && (
          <FormControl required>
            <InputLabel htmlFor="age-required">Label</InputLabel>
            <Select
              value={label || 0}
              onChange={e => {
                setLabel(e.target.value as number);
              }}
              inputProps={{
                id: "age-required"
              }}
            >
              {labels.map((label: any, i: number) => (
                <MenuItem value={i}>{label.name}</MenuItem>
              ))}
            </Select>
            <FormHelperText>Required</FormHelperText>
          </FormControl>
        )}
        <div style={{ height: data.length * 50 + 100 }}>
          <ResponsiveBarCanvas
            margin={{ top: 50, right: 0, bottom: 50, left: 150}}
            minValue={tabDef.minValue}
            maxValue={tabDef.maxValue}
            tooltip={defFunc}
            data={data}
            axisLeft={{
              tickSize: 5,
              tickPadding: 25,
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
