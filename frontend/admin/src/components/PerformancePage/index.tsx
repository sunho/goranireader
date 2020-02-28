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
  FormHelperText,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody
} from "@material-ui/core";
import { FirebaseContext } from "../Firebase";
import {
  Bar,
  ResponsiveBar,
  ResponsiveBarCanvas,
  BarCanvas,
  BarItemProps,
  BarExtendedDatum
} from "@nivo/bar";
import { ClasssContext, ClassInfo } from "../Auth/withClass";
import { UserInsight } from "../../model";
import { tableIcons } from "../StudentPage";
import MaterialTable from "material-table";
import { RouteComponentProps } from "react-router";
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
    marginBottom: 24
  }
});

const PerformancePage: React.FC<RouteComponentProps> = ({history}) => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const commonStyles = useCommonStyle();
  const [raw, setRaw] = useState<UserInsight[]>([]);

  const classes = useStyles();
  useEffect(() => {
    (async () => {
      const res = await firebase.serverComputed(classInfo.currentId!).get();
      const out = await Promise.all(
        res.docs.map(async doc => {
          const useri = await firebase.user(doc.id).get();
          return { ...doc.data(), username: useri.data()!.username, id: doc.id};
        })
      );

      console.log(out);
      setRaw(out as any);
    })();
  }, [classInfo]);
  const ids: Set<string> = new Set<string>();
  raw.forEach(user => {
    if (user.bookPerformance) {
      Object.keys(user.bookPerformance).forEach(id => {
        ids.add(id);
      });
    }
  });


  const data = raw
    .filter(
      x => 'all' in (x.bookPerformance || {})
    )
    .map(row => ({
      id: row.id,
      username: row.username,
      ...row.bookPerformance!['all']
    }))
    .map(row => ({
      ...row,
      wpm: row['wpm'].toFixed(),
      score: (row['score'] * 100).toFixed(2),
      uperc: (row['uperc'] * 100).toFixed(2)
    }));

    const columns: any[] = [
      { title: "Username", field: "username" },
      { title: "Reading Score", field: "rc", type: "numeric" },
      { title: "Read pages", field: "count", type: "numeric" },
    ];

  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      <Typography variant="h5" component="h3" className={commonStyles.header}>
        Performance
      </Typography>
          <MaterialTable
            icons={tableIcons}
            title=""
            columns={columns}
            data={data}
            onRowClick={(e, row) => {
              history.push(`/dashboard/performanceDetail/${row!.id!}${window.location.search}`);
            }}
            options={{
              selection: false,
              paging: false,
              search: false
            }}
          />
    </Container>
  );
};

export default PerformancePage;
