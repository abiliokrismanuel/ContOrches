import http from "k6/http";
import { check } from "k6";
import { Rate, Trend } from "k6/metrics";

// Definisikan metrik
let errorRate = new Rate("errors");
let responseTime = new Trend("response_time", true);

export const options = {
  vus: 10000, // jumlah koneksi (virtual users)
  duration: "10s", // durasi pengujian
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

const BASE_URL = "<url>";

export function browseProduct() {
  const testid = __ENV.TEST_ID || "docker-swarm-browseproduk-10000-inject-worker1"; // Mengambil testid dari environment variable atau default
  const product = products[Math.floor(Math.random() * products.length)];

  // Lakukan GET request untuk melihat detail produk
  let res = http.get(`${BASE_URL}/product/${product}`, {
    tags: {
      name: "browseProduct", // Nama tes
      testid: testid, // Tambahkan testid sebagai tag
    },
  });

  // Periksa apakah statusnya 200
  check(res, {
    "browseProduct status was 200": (r) => r.status === 200,
  });

  // Tambahkan metrik
  errorRate.add(res.status !== 200);
  responseTime.add(res.timings.duration);

}

// Fungsi default yang akan dijalankan oleh K6
export default function () {
  browseProduct();
}
