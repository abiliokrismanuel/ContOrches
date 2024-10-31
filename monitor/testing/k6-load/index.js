import http from "k6/http";
import { check } from "k6";
import { Rate, Trend } from "k6/metrics";

// Custom metrics
let errorRate = new Rate("errors");
let responseTime = new Trend("response_time", true);
let throughput = new Trend("throughput", true);
let latency = new Trend("latency", true); // Latency metric

export const options = {
  vus: 1000, // jumlah koneksi (virtual users)
  duration: "10s", // durasi pengujian
  rps: 100, // request per detik
};

export function index() {
  let res = http.get("/", {
    tags: { name: "index" },
  });
  check(res, {
    "index status was 200": (r) => r.status === 200,
  });
  errorRate.add(res.status !== 200);
  responseTime.add(res.timings.duration);
  latency.add(res.timings.waiting); // Add latency (time waiting for the response)
  throughput.add(res.request.responseBody.length); // Menambahkan throughput
}
