class LegionCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for bi-directional sync between Markdown files and productivity services"
  homepage "https://github.com/endgame-build/legion-cli"
  license "MIT"
  head "https://github.com/endgame-build/legion-cli.git", branch: "main"

  # This will be updated automatically by the release workflow
  url "https://github.com/endgame-build/legion-cli-releases/releases/download/dev-b7158f0/legion_cli-0.1.dev20250630+gb7158f0.tar.gz"
  sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  version "0.1.dev20250630+gb7158f0"

  depends_on "python@3.12"
  depends_on "uv" => :optional

  resource "typer" do
    url "https://files.pythonhosted.org/packages/42/9a/03707b4b3324b02de7110d1cb6b2ba6a13141b11a6a1ca3b06b7e6c53fb4e/typer-0.16.0.tar.gz"
    sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/Jinja2-3.1.5.tar.gz"
    sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dea8131d5b7a75e9c8bafaf46fc37e81cde7d6aa3b8b8e4a8cd0e3/python-dotenv-1.1.0.tar.gz"
    sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.8.tar.gz"
    sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e5/c2/6e3a26945a7ff7cf2854b8825026cf3dd07b681c63e5e8a4a75e0d9139d2/GitPython-3.1.44.tar.gz"
    sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/MarkupSafe-3.0.2.tar.gz"
    sha256 "595e5a2f2a46fb0d1d1b0198e853c319673b8664132fe7c0fd7eb58d09ca15d2"
  end

  def install
    # Create virtualenv
    venv = virtualenv_create(libexec, "python3.12")
    
    # Install dependencies first
    venv.pip_install resources
    
    # Install legion-cli
    venv.pip_install_and_link buildpath
  end

  def caveats
    <<~EOS
      This formula installs the latest development version of legion-cli.
      
      For the stable version, use:
        brew install legion-cli/stable/legion-cli
      
      To configure legion-cli, run:
        legion init
        legion jira setup  # or other service setup commands
      
      For more information, see:
        https://github.com/endgame-build/legion-cli#installation
    EOS
  end

  test do
    # Test basic functionality
    assert_match "Legion", shell_output("#{bin}/legion --help")
    assert_match version.to_s, shell_output("#{bin}/legion version")
    
    # Test service listing
    output = shell_output("#{bin}/legion --help")
    assert_match "jira", output
    
    # Test that we can import the package
    system libexec/"bin/python", "-c", "import legion; print('Import successful')"
  end
end