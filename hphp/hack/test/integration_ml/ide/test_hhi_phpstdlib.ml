(*  Autocomplete for when po_deregister_php_stdlib is on *)

module Test = Integration_test_base

let foo_contents =
  "<?hh // strict
  function idz() : string {
    return \"\";
  }
  function testTypecheck(): string {
    return \"\";
  }
"

let autocomplete_contents =
  "<?hh // strict

function testTypecheck2(): string {
  return idAUTO332;
}
"

let hhi_contents =
  "<?hh // strict
    <<__PHPStdLib>>
    function idx(int $x): string {
      return 5;
    }

    function idy() : string {
      return \"hello\";
    }


"

let hhi_name = "hhi.php"

let test () =
  let hhi_files = [(hhi_name, hhi_contents)] in
  let env = Test.setup_server ~hhi_files () in
  let env = Test.setup_disk env [("foo.php", foo_contents)] in
  Test.assert_no_errors env;
  let env = Test.setup_disk env [("test.php", autocomplete_contents)] in
  let env = Test.connect_persistent_client env in
  let (_, _loop_output) = Test.ide_autocomplete env ("test.php", 4, 12) in
  (* idy and idz should be found, but idx should be missing *)
  (*Test.assert_ide_autocomplete loop_output ["idy"; "idz"]*)
  ()
