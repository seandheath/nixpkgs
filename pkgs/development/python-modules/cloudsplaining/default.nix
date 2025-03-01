{ lib
, boto3
, botocore
, buildPythonPackage
, cached-property
, click
, click-option-group
, fetchFromGitHub
, jinja2
, markdown
, policy-sentry
, pytestCheckHook
, pythonOlder
, pyyaml
, schema
}:

buildPythonPackage rec {
  pname = "cloudsplaining";
  version = "0.4.9";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = pname;
    rev = version;
    sha256 = "sha256-87ZUYHN64gnbF2g9BjPFNbwMaGFxAy3Yb8UdT3BUqC0=";
  };

  propagatedBuildInputs = [
    boto3
    botocore
    cached-property
    click
    click-option-group
    jinja2
    markdown
    policy-sentry
    pyyaml
    schema
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" requirements.txt
  '';

  disabledTests = [
    "test_policy_expansion"
    "test_statement_details_for_allow_not_action"
  ];

  pythonImportsCheck = [
    "cloudsplaining"
  ];

  meta = with lib; {
    description = "Python module for AWS IAM security assessment";
    homepage = "https://github.com/salesforce/cloudsplaining";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
