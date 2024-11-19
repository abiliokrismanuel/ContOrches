# K6_PROMETHEUS_RW_URL=http://<container_prometheus>/api/v1/write k6 run --out experimental-prometheus-rw index.js

# k6 run --summary-trend-stats "min,avg,med,max,p(10),p(25),p(50),p(75),p(90),p(95),p(99)" index.js 

# K6_PROMETHEUS_RW_URL=https://liow.xyz/prometh/api/v1/write k6 run --out experimental-prometheus-rw --summary-trend-stats "min,avg,med,max,p(10),p(25),p(50),p(75),p(90),p(95),p(99)" index.js

# output
k6 run --out json=output.json script.js

# test curl
curl -X POST \
  http://kuber-alb-1627117962.us-east-1.elb.amazonaws.com/cart/checkout \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "email=user123@example.com&street_address=123%20Main%20Street&zip_code=94043&city=Los%20Angeles&state=CA&country=USA&product_id=0PUK6V6EV0&credit_card_number=4432801561520454&credit_card_expiration_month=11&credit_card_expiration_year=2025&credit_card_cvv=123"


# static 
  http://kuber-alb-1627117962.us-east-1.elb.amazonaws.com/static/icons/Hipster_NavLogo.svg