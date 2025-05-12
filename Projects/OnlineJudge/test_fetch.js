async function judge() {
	
	var res = await fetch("http://localhost:2358/submissions", {
  "headers": {
    "accept": "*/*",
    "accept-language": "en-US,en;q=0.9",
    "content-type": "application/json",
    "sec-ch-ua": "\"Chromium\";v=\"136\", \"Google Chrome\";v=\"136\", \"Not.A/Brand\";v=\"99\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"macOS\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "x-requested-with": "XMLHttpRequest"
  },
  "referrer": "http://localhost:2358/dummy-client.html",
  "referrerPolicy": "strict-origin-when-cross-origin",
  "body": "{\"source_code\":\"#include <stdio.h>\\n\\nint main(void) {\\n  char name[10];\\n  scanf(\\\"%s\\\", name);\\n  printf(\\\"hello, %s\\\\n\\\", name);\\n  return 0;\\n}\",\"language_id\":\"50\",\"number_of_runs\":null,\"stdin\":\"Judge0\",\"expected_output\":null,\"cpu_time_limit\":null,\"cpu_extra_time\":null,\"wall_time_limit\":null,\"memory_limit\":null,\"stack_limit\":null,\"max_processes_and_or_threads\":null,\"enable_per_process_and_thread_time_limit\":null,\"enable_per_process_and_thread_memory_limit\":null,\"max_file_size\":null,\"enable_network\":null}",
  "method": "POST",
  "mode": "cors",
  "credentials": "include"
});

	console.log(await res.json())

}