import http from "k6/http";
import { check } from "k6";
import { Rate, Trend } from "k6/metrics";

let errorRate = new Rate("errors");

export const options = {
  vus: 1000, // jumlah koneksi (virtual users)
  duration: '10s',
};

const BASE_URL = "http://kuber-alb-345915462.us-east-1.elb.amazonaws.com";

export function testIndex() {
  const testid = __ENV.TEST_ID || "docker-index-5000-inject-1worker"; // Mengambil testid dari environment variable atau menggunakan default
  
  // Lakukan GET request ke Google
  // static/icons/Hipster_NavLogo.svg
  //let res = http.get(`${BASE_URL}/`, {
  let res = http.get(`${BASE_URL}/static/icons/Hipster_NavLogo.svg`);

  check(res, {
    "status was 200": (r) => r.status === 200,
  });

  errorRate.add(res.status !== 200);
}

// Fungsi default yang akan dijalankan oleh k6
export default function () {
  testIndex();
}