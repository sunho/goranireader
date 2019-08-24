import React from "react";
import withAuthorization from "../Auth/withAuthorization";
import Layout from "../Layout";

const ProgressPage: React.FC = () => {
    return (
        <Layout>
            <div>progress</div>
        </Layout>
    );
};

export default withAuthorization(ProgressPage);