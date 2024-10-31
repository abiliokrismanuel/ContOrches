import http from "k6/http";
import { check } from "k6";
import { Rate, Trend } from "k6/metrics";

let errorRate = new Rate("errors");
let responseTime = new Trend("response_time", true);
let throughput = new Trend("throughput", true);
let latency = new Trend("latency", true); // Latency metric

export const options = {
  vus: 1000, // jumlah koneksi (virtual users)
  duration: "10s", // durasi pengujian
  rps: 100, // request per detik
};

export function setCurrency() {
  const nameTestid = "test-setCurrency-jsbksjfb";
  const currencies = ["EUR", "USD", "JPY", "CAD", "GBP", "TRY"];
  const payload = {
    currency_code: currencies[Math.floor(Math.random() * currencies.length)],
  };
  let res = http.post("/setCurrency", payload, {
    tags: { name: "setCurrencyEndpoint", testid: nameTestid },
  });
  check(res, {
    "setCurrency status was 200": (r) => r.status === 200,
  });
  errorRate.add(res.status !== 200);
  responseTime.add(res.timings.duration);
  latency.add(res.timings.waiting); // Add latency
  throughput.add(res.request.responseBody.length);
}
