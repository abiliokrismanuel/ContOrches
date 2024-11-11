import http from "k6/http";
import { check, sleep } from "k6";
import { Rate, Trend } from "k6/metrics";

// Definisikan metrik
let errorRate = new Rate("errors");
let responseTime = new Trend("response_time", true);

export const options = {
  vus: 10000, // Jumlah pengguna virtual
  duration: "10s", // Durasi pengujian
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

export function addToCart() {
  const testid = __ENV.TEST_ID || "docker-swarm-addcart-10000-inject-master1-worker1";
  const product = products[Math.floor(Math.random() * products.length)];

  // Validasi quantity untuk memastikan nilai positif antara 1 dan 10
  const quantityRandom = Math.floor(Math.random() * 10) + 1; // Hasilnya antara 1 hingga 10

  // Cek nilai sebelum dikirim
  // console.log(`product_id: ${product}, quantity: ${quantityRandom}`);

  // Mengubah payload ke format x-www-form-urlencoded
  const payload = `product_id=${encodeURIComponent(product)}&quantity=${encodeURIComponent(quantityRandom)}`;

  let cartRes = http.post(`${BASE_URL}/cart`, payload, {
    headers: {
      "Content-Type": "application/x-www-form-urlencoded", // Set Content-Type
           //"Accept": "application/json", // Menambahkan header Accept
    }
  });

  check(cartRes, {
    "addToCart success": (r) => r.status === 200 || r.status === 302,
  });

  errorRate.add(cartRes.status !== 200 && cartRes.status !== 302);
  responseTime.add(cartRes.timings.duration);


}

export default function () {
  addToCart();
}

//curl -X POST http://<url>/cart -H "Content-Type: application/x-www-form-urlencoded" -d "product_id=0PUK6V6EV0&quantity=10"