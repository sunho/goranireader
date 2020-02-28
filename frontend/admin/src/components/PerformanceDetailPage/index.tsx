import React, { useContext, useState, useEffect, useRef } from "react";
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
  TableBody,
  Grid
} from "@material-ui/core";
import { FirebaseContext } from "../Firebase";
import { ClasssContext, ClassInfo } from "../Auth/withClass";
import { UserInsight } from "../../model";
import { tableIcons } from "../StudentPage";
import MaterialTable from "material-table";
import { ResponsiveLine } from "@nivo/line";
import { ResponsiveCalendar } from "@nivo/calendar";
import { RouteComponentProps } from "react-router";

function getDate() {
  let d = new Date(),
    month = "" + (d.getMonth() + 1),
    day = "" + d.getDate(),
    year = d.getFullYear();

  if (month.length < 2) month = "0" + month;
  if (day.length < 2) day = "0" + day;

  return [year, month, day].join("-");
}

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
  },
  legend: {
    marginLeft: 24,
    paddingTop: 24
  },
  subHeader: {
    marginTop: 24,
    marginBottom: 12
  }
});

const PerformanceDetailPage: React.FC<
  RouteComponentProps<{ userId: string }>
> = ({ match, history }) => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const commonStyles = useCommonStyle();
  const styles = useStyles();
  const [raw, setRaw] = useState<UserInsight[]>([]);
  const [labels, setLabels] = useState<any[]>([]);
  const [label, setLabel] = useState<number>(0);
  useEffect(() => {
    (async () => {
      const res = await firebase.serverComputed(classInfo.currentId!).get();
      const out = await Promise.all(
        res.docs.map(async doc => {
          const useri = await firebase.user(doc.id).get();
          return {
            ...doc.data(),
            username: useri.data()!.username,
            id: doc.id
          };
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

  useEffect(() => {
    Promise.all(
      Array.from(ids.values()).map(async id => {
        if (id === "all") {
          return {
            title: "(all)",
            id: "all"
          };
        }
        const doc = await firebase
          .books()
          .doc(id)
          .get();
        return { ...doc.data(), id: doc.id };
      })
    ).then((books: any) => {
      setLabels(books.sort((x: any, y: any) => x.title < y.title));
    });
  }, [raw]);

  const data = raw.find(x => x.id === match.params.userId);
  const columns1: any[] = [
    { title: "Sentence", field: "sentence" },
    { title: "Unknown", field: "unknown", type: "numeric" },
    { title: "Unknown word count", field: "uwordCount", type: "numeric" }
  ];
  const columns2: any[] = [
    { title: "Word", field: "word" },
    { title: "Count", field: "count", type: "numeric" }
  ];

  const graph = (y: string, data: any, hide: boolean = false) => (
    <>
      {!hide &&
      <Typography variant="body1" component="p" className={styles.legend}>
        {y}
      </Typography>
      }
      <div style={{ height: 300 }}>
        <ResponsiveLine
          data={[{ id: y, data: data }]}
          margin={{ top: 50, right: 60, bottom: 50, left: 60 }}
          xScale={{ type: "point" }}
          yScale={{ type: "linear", stacked: true, min: "auto", max: "auto" }}
          axisTop={null}
          axisRight={null}
          axisLeft={{
            orient: "left",
            tickSize: 5,
            tickPadding: 5,
            tickRotation: 0,
            legendPosition: "middle"
          }}
          axisBottom={{
            orient: "bottom",
            tickSize: 5,
            tickPadding: 5,
            tickRotation: 0,
            legend: "date",
            legendOffset: 36,
            legendPosition: "middle"
          }}
          colors={{ scheme: "set2" }}
          pointSize={10}
          pointColor={{ theme: "background" }}
          pointBorderWidth={2}
          pointBorderColor={{ from: "serieColor" }}
          pointLabel="y"
          pointLabelYOffset={-12}
          useMesh={true}
        />
      </div>
    </>
  );

  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      {data && labels[label] && (
        <>
          
          <Typography
            variant="h5"
            component="h5"
            className={commonStyles.header}
          >
            {data.username}
          </Typography>
          <FormControl className={styles.pos} required>
            <InputLabel htmlFor="age-required">Book</InputLabel>
            <Select
              value={label || 0}
              onChange={e => {
                setLabel(e.target.value as number);
              }}
              inputProps={{
                id: "age-required"
              }}
            >
              {labels.map((x: any, i) => (
                <MenuItem value={i}>{x.title}</MenuItem>
              ))}
            </Select>
            <FormHelperText>Required</FormHelperText>
          </FormControl>
          <Typography variant="h6" component="h6" className={styles.subHeader}>
            Reading score
          </Typography>
          <Paper>{graph("Reading Score", data.ymwPerformance![labels[label].id].rc, true)}</Paper>
          <Typography variant="h6" component="h6" className={styles.subHeader}>
            Read pages
          </Typography>
          <Paper>
            <div style={{ height: 300 }}>
              <ResponsiveCalendar
                data={data.activity![labels[label].id]}
                from="2019-01-01"
                to={new Date()}
                emptyColor="#eeeeee"
                colors={["#61cdbb", "#97e3d5", "#e8c1a0", "#f47560"]}
                margin={{ top: 40, right: 40, bottom: 40, left: 40 }}
                yearSpacing={40}
                monthBorderColor="#ffffff"
                dayBorderWidth={2}
                dayBorderColor="#ffffff"
                legends={[
                  {
                    anchor: "bottom-right",
                    direction: "row",
                    translateY: 36,
                    itemCount: 4,
                    itemWidth: 42,
                    itemHeight: 36,
                    itemsSpacing: 14,
                    itemDirection: "right-to-left"
                  }
                ]}
              />
            </div>
          </Paper>
          <Typography variant="h6" component="h6" className={styles.subHeader}>
            Matrics
          </Typography>
          <Grid container spacing={4}>
            <Grid item xs={6}>
              <Paper>{graph("wpm", data.ymwPerformance![labels[label].id].wpm.map(x => ({ ...x, y: x.y.toFixed() })))}</Paper>
            </Grid>
            <Grid item xs={6}>
              <Paper>
                {graph(
                  "Unfamiliar Word Percentage",
                  data.ymwPerformance![labels[label].id].uperc.map(x => ({ ...x, y: (x.y * 100).toFixed(2) }))
                )}
              </Paper>
            </Grid>
            <Grid item xs={6}>
              <Paper>
                {graph(
                  "Quiz Score Percentile",
                  data.ymwPerformance![labels[label].id].score.map(x => ({ ...x, y: (x.y * 100).toFixed(2)}))
                )}
              </Paper>
            </Grid>
          </Grid>
          <Grid container spacing={4}>
            {data.unknownSentences && (
              <Grid item xs={6}>
                <Typography
                  variant="h6"
                  component="h6"
                  className={styles.subHeader}
                >
                  Unknown sentences
                </Typography>
                <MaterialTable
                  icons={tableIcons}
                  title=""
                  columns={columns1}
                  data={data.unknownSentences[labels[label].id]}
                  options={{
                    selection: false,
                    paging: false,
                    search: false
                  }}
                  onRowClick={(e, row:any) => {
                    history.push(`/dashboard/reader/?bookid=${row['bookId']}&sid=${row['sid']}&uwords=${row['uwords'].join(',')}`);
                  }}
                />
              </Grid>
            )}
            {data.unknownWords && (
              <Grid item xs={6}>
                <Typography
                  variant="h6"
                  component="h6"
                  className={styles.subHeader}
                >
                  Unknown words
                </Typography>
                <MaterialTable
                  icons={tableIcons}
                  title=""
                  columns={columns2}
                  data={data.unknownWords[labels[label].id]}
                  options={{
                    selection: false,
                    paging: false,
                    search: false
                  }}
                />
              </Grid>
            )}
          </Grid>
        </>
      )}
    </Container>
  );
};

export default PerformanceDetailPage;
