import React from "react";
import withAuthorization from "../Auth/withAuthorization";

const ProgressPage: React.FC = () => {
    return (
        <div>progress</div>
    );
};

export default withAuthorization(ProgressPage);