import { forwardRef, useRef, useEffect } from "react";

import AddBox from "@material-ui/icons/AddBox";
import ArrowUpward from "@material-ui/icons/ArrowUpward";
import Check from "@material-ui/icons/Check";
import ChevronLeft from "@material-ui/icons/ChevronLeft";
import ChevronRight from "@material-ui/icons/ChevronRight";
import Clear from "@material-ui/icons/Clear";
import DeleteOutline from "@material-ui/icons/DeleteOutline";
import Edit from "@material-ui/icons/Edit";
import FilterList from "@material-ui/icons/FilterList";
import FirstPage from "@material-ui/icons/FirstPage";
import LastPage from "@material-ui/icons/LastPage";
import Remove from "@material-ui/icons/Remove";
import SaveAlt from "@material-ui/icons/SaveAlt";
import Search from "@material-ui/icons/Search";
import ViewColumn from "@material-ui/icons/ViewColumn";
import React, { useContext } from "react";
import {
  Container,
  Paper,
  Typography,
  createMuiTheme,
  MuiThemeProvider
} from "@material-ui/core";
import { useCommonStyle } from "../../style";
import MaterialTable, { Column } from "material-table";
import { FirebaseContext } from "../Firebase";
import { ClasssContext } from "../Auth/withClass";
import "firebase/firestore";

const theme = createMuiTheme({
  overrides: {
    MuiTableCell: {
      paddingCheckbox: {
        padding: "14px 40px 14px 16px"
      }
    }
  }
});

const tableIcons = {
  Add: forwardRef<any>((props, ref) => <AddBox {...props} ref={ref} />),
  Check: forwardRef<any>((props, ref) => <Check {...props} ref={ref} />),
  Clear: forwardRef<any>((props, ref) => <Clear {...props} ref={ref} />),
  Delete: forwardRef<any>((props, ref) => (
    <DeleteOutline {...props} ref={ref} />
  )),
  DetailPanel: forwardRef<any>((props, ref) => (
    <ChevronRight {...props} ref={ref} />
  )),
  Edit: forwardRef<any>((props, ref) => <Edit {...props} ref={ref} />),
  Export: forwardRef<any>((props, ref) => <SaveAlt {...props} ref={ref} />),
  Filter: forwardRef<any>((props, ref) => <FilterList {...props} ref={ref} />),
  FirstPage: forwardRef<any>((props, ref) => (
    <FirstPage {...props} ref={ref} />
  )),
  LastPage: forwardRef<any>((props, ref) => <LastPage {...props} ref={ref} />),
  NextPage: forwardRef<any>((props, ref) => (
    <ChevronRight {...props} ref={ref} />
  )),
  PreviousPage: forwardRef<any>((props, ref) => (
    <ChevronLeft {...props} ref={ref} />
  )),
  ResetSearch: forwardRef<any>((props, ref) => <Clear {...props} ref={ref} />),
  Search: forwardRef<any>((props, ref) => <Search {...props} ref={ref} />),
  SortArrow: forwardRef<any>((props, ref) => (
    <ArrowUpward {...props} ref={ref} />
  )),
  ThirdStateCheck: forwardRef<any>((props, ref) => (
    <Remove {...props} ref={ref} />
  )),
  ViewColumn: forwardRef<any>((props, ref) => (
    <ViewColumn {...props} ref={ref} />
  ))
};

const StudentPage: React.FC = () => {
  const commonStyles = useCommonStyle();
  const classInfo = useContext(ClasssContext)!;
  const firebase = useContext(FirebaseContext)!;
  const tableRef = useRef<any | null>(null);
  useEffect(() => {
    tableRef.current && tableRef.current.onQueryChange();
    console.log("asdfsadf");
  }, [classInfo.currentId]);
  const columns: any[] = [
    { title: "Id", field: "id", hidden: true, editable: "never" },
    { title: "Username", field: "username" },
    { title: "Age", field: "age", type: "numeric" },
    {
      title: "Deleted",
      field: "deleted",
      type: "boolean",
      editable: "never",
      hidden: true
    },
    {
      title: "Registered",
      field: "fireId",
      editable: "never",
      render: (rowData: any) => (rowData && rowData.fireId ? <>Yes</> : <>No</>)
    },
    { title: "Secret Code", field: "secretCode", editable: "never" }
  ];
  return (
    <MuiThemeProvider theme={theme}>
      <Container maxWidth="lg" className={commonStyles.container}>
        <Typography variant="h5" className={commonStyles.header} component="h3">
          Students
        </Typography>
        <MaterialTable
          tableRef={(node: any) => {
            tableRef.current = node;
          }}
          icons={tableIcons}
          title=""
          columns={columns}
          data={async query => {
            const data = await firebase
              .users()
              .where("classId", "==", classInfo.currentId!)
              .where("deleted", "==", false)
              .get()
              .then(res => res.docs)
              .then(docs => docs.map(doc => ({ ...doc.data(), id: doc.id })));
            return { data: data, page: 0, totalCount: 1 } as any;
          }}
          editable={{
            onRowAdd: async (newData: any) => {
              newData.classId = classInfo.currentId!;
              newData.deleted = false;
              await firebase.users().add(newData);
            },
            onRowUpdate: async (newData, oldData) => {
              delete newData.id;
              await firebase.user(oldData.id).set(newData);
            },
            onRowDelete: async oldData => {
              const newData = Object.assign({}, oldData);
              delete newData.tableData;
              const id = newData.id;
              delete newData.id;
              oldData.deleted = true;
              await firebase.user(id).set(oldData);
            }
          }}
          options={{
            selection: false,
            paging: false,
            search: false,
          }}
        />
      </Container>
    </MuiThemeProvider>
  );
};

export default StudentPage;
