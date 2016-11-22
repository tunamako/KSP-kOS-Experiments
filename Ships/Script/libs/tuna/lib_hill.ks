{
    function hillClimber {
        parameter
            components, //list of values with initial guesses
            scoreFunction, //delegate that takes components and returns a scorer
            maximumScoreError,
            maximumScoreDelta.

        return seek(lexicon(
            "components", components,
            "score", -1e15,
            "scoreFunction", scoreFunction,
            "targetScore", targetScore,
            "maximumScoreError", maximumScoreError,
            "maximumScoreDelta", maximumScoreDelta
        )).
    }

    function seek {
        parameter scorecard.
        local tryComponents is scorecard["components"].
        local tryScore is scorecard["score"].
        local startTime is time:seconds.
        until tryScore > previousScore or time:seconds - startTime > 10 {
            set tryComponents to modifyComponents(scorecard["components"] ).
            set tryScore to scorecard["scoreFunction"](tryComponents).
        }

        if scorecard["targetScore"] - tryScore < scorecard["maximumScoreError"] or
           tryScore - scorecard["score"] < scorecard["maximumScoreDelta"]
        {
            return scorecard.
        } else {
            set scorecard["components"] to tryComponents.
            set scorecard["score"] to tryScore.
            return seek(scorecard).
        }
    }

    function modifyComponents(components) {

    }

    export(lex(
    "ver", "0.0.1",
    "seek", seek@,
    "hillClimber", hillClimber@
    )).
}
