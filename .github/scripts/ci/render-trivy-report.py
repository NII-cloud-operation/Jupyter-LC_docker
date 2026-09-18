import argparse
import json
from collections import Counter


SEVERITIES = ('CRITICAL', 'HIGH', 'MEDIUM', 'LOW', 'UNKNOWN')
SEVERITY_ORDER = {severity: index for index, severity in enumerate(SEVERITIES)}
COMMENT_MARKER = '<!-- trivy-image-scan -->'


def markdown_escape(value):
    return str(value or '-').replace('\n', ' ').replace('|', '\\|')


def get_findings(report):
    return [
        (result.get('Target'), vulnerability)
        for result in report.get('Results', [])
        for vulnerability in result.get('Vulnerabilities') or []
    ]


def render_report(report, image, commit, run_url):
    findings = get_findings(report)
    counts = Counter(
        vulnerability.get('Severity', 'UNKNOWN').upper()
        for _, vulnerability in findings
    )
    fixable_counts = Counter(
        vulnerability.get('Severity', 'UNKNOWN').upper()
        for _, vulnerability in findings
        if vulnerability.get('FixedVersion')
    )

    lines = [
        COMMENT_MARKER,
        '## Container image vulnerability scan',
        '',
        f'- Image: `{markdown_escape(image)}`',
        f'- Commit: [`{commit[:12]}`]({run_url.rsplit("/actions/runs/", 1)[0]}/commit/{commit})',
        f'- Workflow run: [details]({run_url})',
        f'- Findings: **{len(findings)}** '
        f'({sum(fixable_counts.values())} with a fix available)',
        '',
        '| Severity | Total | Fix available |',
        '| --- | ---: | ---: |',
    ]
    for severity in SEVERITIES:
        lines.append(
            f'| {severity} | {counts[severity]} | {fixable_counts[severity]} |',
        )

    important = sorted(
        (
            finding
            for finding in findings
            if finding[1].get('Severity', 'UNKNOWN').upper() in {'CRITICAL', 'HIGH'}
        ),
        key=lambda finding: (
            SEVERITY_ORDER.get(
                finding[1].get('Severity', 'UNKNOWN').upper(),
                len(SEVERITIES),
            ),
            finding[1].get('VulnerabilityID', ''),
            finding[1].get('PkgName', ''),
            finding[0] or '',
        ),
    )
    lines.extend([
        '',
        '### High-priority findings',
        '',
    ])
    if important:
        lines.extend([
            '| Severity | Vulnerability | Package | Target | Installed | Fixed |',
            '| --- | --- | --- | --- | --- | --- |',
        ])
        for target, vulnerability in important[:20]:
            lines.append(
                '| {severity} | {identifier} | {package} | {target} | {installed} | {fixed} |'.format(
                    severity=markdown_escape(vulnerability.get('Severity')),
                    identifier=markdown_escape(vulnerability.get('VulnerabilityID')),
                    package=markdown_escape(vulnerability.get('PkgName')),
                    target=markdown_escape(target),
                    installed=markdown_escape(vulnerability.get('InstalledVersion')),
                    fixed=markdown_escape(vulnerability.get('FixedVersion')),
                ),
            )
        if len(important) > 20:
            lines.extend([
                '',
                f'_Showing 20 of {len(important)} HIGH/CRITICAL findings._',
            ])
    else:
        lines.append('No HIGH or CRITICAL findings were detected.')

    lines.extend([
        '',
        '> This scan is currently reporting-only and establishes the vulnerability baseline.',
        '> The complete JSON and SARIF reports are attached to the workflow run.',
        '',
    ])
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--image', required=True)
    parser.add_argument('--commit', required=True)
    parser.add_argument('--run-url', required=True)
    args = parser.parse_args()

    with open(args.input, encoding='utf-8') as report_file:
        report = json.load(report_file)

    rendered = render_report(
        report,
        image=args.image,
        commit=args.commit,
        run_url=args.run_url,
    )
    with open(args.output, 'w', encoding='utf-8') as output_file:
        output_file.write(rendered)


if __name__ == '__main__':
    main()
