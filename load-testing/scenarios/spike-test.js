import http from 'k6/http';

export let options = {
  stages: [
    { duration: '30s', target: 50 },
    { duration: '30s', target: 0 },
  ],
};

export default function () {
  http.get('http://localhost:30007');
}
