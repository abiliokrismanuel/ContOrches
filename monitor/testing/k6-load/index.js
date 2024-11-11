import http from "k6/http";
import { check } from "k6";
import { Rate, Trend } from "k6/metrics";

let errorRate = new Rate("errors");
let responseTime = new Trend("response_time", true);

export const options = {
  vus: 10000, // jumlah koneksi (virtual users)
  duration: '10s',
};

const BASE_URL = "<url>";

export function testIndex() {
  const testid = __ENV.TEST_ID || "docker-swarm-10000-con-inject-master1-worker1"; // Mengambil testid dari environment variable atau menggunakan default
  
  // Lakukan GET request ke Google
  let res = http.get(`${BASE_URL}/`, {
    tags: {
      name: "test-index", // Menandai nama tes ini
      testid: testid, // Tambahkan testid sebagai tag
    }
  });

  check(res, {
    "status was 200": (r) => r.status === 200,
  });

  errorRate.add(res.status !== 200);
  responseTime.add(res.timings.duration);
}

// Fungsi default yang akan dijalankan oleh k6
export default function () {
  testIndex();
}