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
        try await fetch("/op/fib", .options(searchParams: ["input": input])).text()
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
