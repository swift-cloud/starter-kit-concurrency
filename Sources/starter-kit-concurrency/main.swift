import Compute
import CollectionConcurrencyKit

let router = Router()

router.get("/serial") { req, res in
    let inputs = req.searchParams["inputs", default: "0"].components(separatedBy: ",")
    let values = inputs.map { fibonacciSeries(.init($0) ?? 0) }
    let text = values.map(String.init).joined(separator: ", ")
    try await res.status(200).send(text)
}

router.get("/concurrent") { req, res in
    let inputs = req.searchParams["inputs", default: "0"].components(separatedBy: ",")
    let values = try await inputs.concurrentMap { input in
        let _res = try await fetch("/op/fib?input=\(input)")
        console.log("status:", _res.status)
        return try await _res.text()
    }
    let text = values.joined(separator: ", ")
    try await res.status(200).send(text)
}

router.get("/op/fib") { req, res in
    let input = Int(req.searchParams["input"] ?? "0") ?? 0
    let value = fibonacciSeries(input)
    try await res.status(200).send("\(value)")
}

try await router.listen()
