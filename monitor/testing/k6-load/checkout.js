import http from "k6/http";
import { check } from "k6";
import { Rate, Trend } from "k6/metrics";
import { faker } from "@faker-js/faker";

let errorRate = new Rate("errors");
let responseTime = new Trend("response_time", true);
let throughput = new Trend("throughput", true);
let latency = new Trend("latency", true); // Latency metric

export const options = {
  vus: 1000, // jumlah koneksi (virtual users)
  duration: "10s", // durasi pengujian
  rps: 100, // request per detik
};

const products = [
  "0PUK6V6EV0",
  "1YMWWN1N4O",
  "2ZYFJ3GM2N",
  "66VCHSJNUP",
  "6E92ZMYYFZ",
  "9SIQT8TOJO",
  "L9ECAV7KIM",
  "LS4PSXUNUM",
  "OLJCESPC7Z",
];

export function checkout() {
  const product = products[Math.floor(Math.random() * products.length)];
  const payload = {
    email: faker.internet.email(),
    street_address: faker.address.streetAddress(),
    zip_code: faker.address.zipCode(),
    city: faker.address.city(),
    state: faker.address.stateAbbr(),
    country: faker.address.country(),
    credit_card_number: faker.finance.creditCardNumber(),
    credit_card_expiration_month: Math.floor(Math.random() * 12) + 1,
    credit_card_expiration_year: new Date().getFullYear() + 1,
    credit_card_cvv: Math.floor(Math.random() * 900) + 100,
  };
  let res = http.post("/cart/checkout", payload, {
    tags: { name: "checkout" },
  });
  check(res, {
    "checkout status was 200": (r) => r.status === 200,
  });
  errorRate.add(res.status !== 200);
  responseTime.add(res.timings.duration);
  latency.add(res.timings.waiting); // Add latency
  throughput.add(res.request.responseBody.length);
}
