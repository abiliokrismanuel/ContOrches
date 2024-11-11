import http from "k6/http";
import { check } from "k6";
import { Rate, Trend } from "k6/metrics";

let errorRate = new Rate("errors");
let responseTime = new Trend("response_time", true);

const BASE_URL = "<url>"; // Ganti dengan URL dasar aplikasi Anda

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

// Fungsi untuk menghasilkan data acak (email, street address, zip code)
function generateRandomData() {
  const email = `user${Math.floor(Math.random() * 1000)}@example.com`;
  const street_address = `${Math.floor(Math.random() * 1000)} Main Street`;

  return { email, street_address };
}

// Memilih produk acak dari daftar
const selectedProduct = products[Math.floor(Math.random() * products.length)];

export default function checkout() {
  const testid = __ENV.TEST_ID || "docker-swarm-cekout-10000-inject-master1-worker1"; // Mengambil testid dari environment variable atau default
  const { email, street_address } = generateRandomData();

  const payload = `email=${email}&street_address=${street_address}&zip_code=94043&city=Los Angeles&state=CA&country=USA&product_id=${selectedProduct}&credit_card_number=4432801561520454&credit_card_expiration_month=11&credit_card_expiration_year=2025&credit_card_cvv=123`;

  const headers = { "Content-Type": "application/x-www-form-urlencoded" };

  let res = http.post(`${BASE_URL}/cart/checkout`, payload, { headers, tags: { name: "checkout" } });

  check(res, {
    "checkout status was 200": (r) => r.status === 200,
  });

  // Log payload untuk melihat data yang dihasilkan
  //console.log("Generated Payload:", payload);

  // Record error if status is not 200
  errorRate.add(res.status !== 200);
  
  // Record response time, latency, and throughput
  responseTime.add(res.timings.duration);
}
