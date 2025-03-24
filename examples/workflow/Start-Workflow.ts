import winston from "winston";

const logger = winston.createLogger({
  level: "info",
  transports: [new winston.transports.Console()]
});

interface WorkflowParams {
  userId: string;
  action: string;
  timestamp: number;
}

interface WorkflowPayload {
  workflowId: string;
  params: WorkflowParams;
}

const workflowPayload: WorkflowPayload = {
  workflowId: "Flow 1",
  params: {
    userId: "user123",
    action: "start_process",
    timestamp: Date.now()
  }
};

fetch("http://127.0.0.1:1880/workflows/start", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify(workflowPayload)
})
  .then((response) => {
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response.json();
  })
  .then((data) => {
    logger.info("Success:", data);
  })
  .catch((error) => {
    logger.error("Error:", error);
  });
