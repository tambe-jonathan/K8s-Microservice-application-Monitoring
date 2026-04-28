import http from 'k6/http';

export let options = {
  vus: 100,
  duration: '1m',
};

export default function () {
  http.get('http://localhost:30007');
}
