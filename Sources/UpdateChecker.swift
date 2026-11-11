import AppKit
import Foundation

final class UpdateChecker {
    static var timer: Timer?
    static func start(repository: String) {
        guard !CommandLine.arguments.contains(where: { $0.hasPrefix("--") }) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { check(repository: repository) }
        timer = Timer.scheduledTimer(withTimeInterval: 24 * 60 * 60, repeats: true) { _ in check(repository: repository) }
    }
    static func check(repository: String) {
        guard let current = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let url = URL(string: "https://api.github.com/repos/yuhanfu513-ops/\(repository)/releases/latest") else { return }
        var request = URLRequest(url: url, timeoutInterval: 15)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard (response as? HTTPURLResponse)?.statusCode == 200, let data,
                  let release = try? JSONDecoder().decode(Release.self, from: data),
                  let latest = version(release.tag_name), let installed = version(current),
                  latest.compare(installed, options: .numeric) == .orderedDescending,
                  let link = URL(string: release.html_url), link.scheme == "https", link.host == "github.com" else { return }
            DispatchQueue.main.async {
                let key = "update-notice-\(repository)-\(release.tag_name)"
                if let last = UserDefaults.standard.object(forKey: key) as? Date, Date().timeIntervalSince(last) < 86400 { return }
                UserDefaults.standard.set(Date(), forKey: key)
                let alert = NSAlert()
                alert.messageText = "发现新版本 \(release.tag_name)"
                alert.informativeText = "当前版本为 \(current)。是否打开 GitHub 发布页面查看更新？"
                alert.addButton(withTitle: "查看更新")
                alert.addButton(withTitle: "稍后再说")
                if alert.runModal() == .alertFirstButtonReturn { NSWorkspace.shared.open(link) }
            }
        }.resume()
    }
    private struct Release: Decodable { let tag_name: String; let html_url: String }
    private static func version(_ tag: String) -> String? {
        let value = tag.hasPrefix("v") ? String(tag.dropFirst()) : tag
        guard !value.isEmpty, value.split(separator: ".", omittingEmptySubsequences: false).allSatisfy({ !$0.isEmpty && $0.allSatisfy(\.isNumber) }) else { return nil }
        return value
    }
}
