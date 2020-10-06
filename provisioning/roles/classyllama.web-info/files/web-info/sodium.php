<?php
if (extension_loaded("sodium")) {
  echo "SODIUM_LIBRARY_VERSION:", SODIUM_LIBRARY_VERSION, PHP_EOL;
} else {
  echo "sodium extension is not loaded", PHP_EOL;
}
