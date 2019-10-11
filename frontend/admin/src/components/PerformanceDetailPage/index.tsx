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
  subHeader: {
    marginTop: 24,
    marginBottom: 12
  }
});

const PerformanceDetailPage: React.FC<
  RouteComponentProps<{ userId: string }>
> = ({ match }) => {
  const firebase = useContext(FirebaseContext)!;
  const classInfo = useContext(ClasssContext)!;
  const commonStyles = useCommonStyle();
  const styles = useStyles();
  const [raw, setRaw] = useState<UserInsight[]>([]);

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

  const graph = (y: string, data: any) => (
    <div style={{ height: 300 }}>
      <ResponsiveLine
        data={[{ id: y, data: data }]}
        margin={{ top: 50, right: 110, bottom: 50, left: 60 }}
        xScale={{ type: "point" }}
        yScale={{ type: "linear", stacked: true, min: "auto", max: "auto" }}
        axisTop={null}
        axisRight={null}
        axisBottom={{
          orient: "bottom",
          tickSize: 5,
          tickPadding: 5,
          tickRotation: 0,
          legend: "date",
          legendOffset: 36,
          legendPosition: "middle"
        }}
        axisLeft={{
          orient: "left",
          tickSize: 5,
          tickPadding: 5,
          tickRotation: 0,
          legend: y,
          legendOffset: -40,
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
        legends={[
          {
            anchor: "bottom-right",
            direction: "column",
            justify: false,
            translateX: 100,
            translateY: 0,
            itemsSpacing: 0,
            itemDirection: "left-to-right",
            itemWidth: 80,
            itemHeight: 20,
            itemOpacity: 0.75,
            symbolSize: 12,
            symbolShape: "circle",
            symbolBorderColor: "rgba(0, 0, 0, .5)",
            effects: [
              {
                on: "hover",
                style: {
                  itemBackground: "rgba(0, 0, 0, .03)",
                  itemOpacity: 1
                }
              }
            ]
          }
        ]}
      />
    </div>
  );

  return (
    <Container maxWidth="lg" className={commonStyles.container}>
      {data && (
        <>
          <Typography
            variant="h5"
            component="h5"
            className={commonStyles.header}
          >
            {data.username}
          </Typography>
          <Typography variant="h6" component="h6"
            className={styles.subHeader}>
              Reading score
          </Typography>
          <Paper>
          {graph("Reading Score", data.ymwPerformance!.rc)}
          </Paper>
          <Typography variant="h6" component="h6"
            className={styles.subHeader}>
            Read pages
          </Typography>
          <Paper>
            <div style={{ height: 300 }}>
              <ResponsiveCalendar
                data={data.activity!}
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
          <Typography variant="h6" component="h6"
            className={styles.subHeader}>
            Matrics
          </Typography>
          <Paper>
            <Grid container>
              <Grid item xs={6}>
                {graph("wpm", data.ymwPerformance!.wpm)}
              </Grid>
              <Grid item xs={6}>
                {graph(
                  "Unfamiliar Word Percentage",
                  data.ymwPerformance!.uperc.map(x => ({ ...x, y: x.y * 100 }))
                )}
              </Grid>
              <Grid item xs={6}>
                {graph(
                  "Quiz Score Percentile",
                  data.ymwPerformance!.score.map(x => ({ ...x, y: x.y * 100 }))
                )}
              </Grid>
            </Grid>
          </Paper>
          {data.unknownSentences && (
            <>
          <Typography variant="h6" component="h6" className={styles.subHeader}>
            Unknown sentences
          </Typography>
            <MaterialTable
              icons={tableIcons}
              title=""
              columns={columns1}
              data={data.unknownSentences}
              options={{
                selection: false,
                paging: false,
                search: false
              }}
            />
            </>
          )}
          {data.unknownWords && (
            <>
          <Typography variant="h6" component="h6" className={styles.subHeader}>
            Unknown words
          </Typography>
            <MaterialTable
              icons={tableIcons}
              title=""
              columns={columns2}
              data={data.unknownWords}
              options={{
                selection: false,
                paging: false,
                search: false
              }}
            />
            </>
          )}
        </>
      )}
    </Container>
  );
};

export default PerformanceDetailPage;
