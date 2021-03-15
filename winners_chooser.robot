*** Settings ***
Library           Collections
Library           String
Library           CryptoLibrary    variable_decryption=True
Library           ContestUtils.py
Library           OperatingSystem


*** Variables ***
${PRIMARY_ANSWER}=      crypt:dR7yT4WceddtEkCGCEPkO/cJGdv0O43JNS21xiVgYlpfQX2zj9qkkcVSSAn+SKz9mdJs3gyDjCM1Ai2U3qrCD0WBjvemRAdotabESw==
${SECONDARY_ANSWER}=    crypt:8ZSIMenSw+ZhCCxRsZ33t7O+cuiNB+chB4d5QA6xvTQSimanVpZgf1MSh+t8nBxfPYa3Pka3KATj3hwB+qSyt2dNlb9dpUl7vM+Xi1lVhUTjm8GPVBygGQ==
${NUMBER_OF_WINNERS}=   ${10}
@{WINNERS}=             @{EMPTY}


*** Tasks ***
Find RoboCon 2021 Contest Winners
    ${answers}=             Get Answers
    ${unique_answers}=      Filter Out Duplicates           ${answers}
    @{potential_winners}    Filter For Correct Answers      ${unique_answers}
    Draw Winners From       @{potential_winners}
    Log To Console          \n
    Save And Show Winners
    Reveal Secret Messages  ${PRIMARY_ANSWER}               ${SECONDARY_ANSWER}


*** Keywords ***
=
    [Arguments]     ${arg}
    [Return]        ${arg}

Filter Out Duplicates
    [Arguments]             ${answers}
    ${unique_answers}=      Create Dictionary
    FOR    ${answer}   IN   @{answers}
        ${mail}=            Convert To Lower Case   ${answer}[Your e-mail address]
        Set To Dictionary   ${unique_answers}       ${mail}=${answer}
    END
    [Return]                ${unique_answers.values()}

Filter For Correct Answers
    [Arguments]             ${unique_answers}
    ${primary_corrects}     Create List
    ${secondary_corrects}   Create List
    FOR    ${answer}   IN   @{unique_answers}
        IF    $answer["Important Message"] == $PRIMARY_ANSWER
            Append To List  ${primary_corrects}     ${answer}
        ELSE IF    $answer["Important Message"] == $SECONDARY_ANSWER
            Append To List  ${secondary_corrects}   ${answer}
        END
    END
    [Return]    ${primary_corrects}    ${secondary_corrects}

Draw Winner From
    [Arguments]         ${potential_wins}
    ${max_s}    =       ${{len($potential_wins)-1}}
    Append To List      ${WINNERS}      ${{$potential_wins.pop(random.randint(0, $max_s))}}

Draw Winners From
    [Arguments]         ${primaries}    ${secondaries}
    FOR    ${i}    IN RANGE    ${NUMBER_OF_WINNERS}
        IF    len($primaries) > 0
            Draw Winner From    ${primaries}
        ELSE IF    len($secondaries) > 0
            Draw Winner From    ${secondaries}
        ELSE
            Exit For Loop
        END
    END

Save And Show Winners
    ${public_winners}=      Evaluate        [(winner["Nickname"], winner["Your e-mail address"]) for winner in $winners]
    Create File             winners.json    ${{json.dumps($WINNERS, indent=2)}}
    Display Winners         ${public_winners}

Display Winners
    [Arguments]             ${public_winners}
    Log To Console          RoboCon 2021 Contest Winners are:
    Log Winner              Name:    Mail:
    Log To Console          =============================================
    FOR    ${winner}   IN   @{public_winners}
        ${prefix}    ${domain}              Split String    ${winner}[1]    @
        IF  len($prefix) < 3
            ${anonymized_prefix}    =       ${{'*' * len($prefix)}}
        ELSE
            ${anonymized_prefix}    =       ${prefix}[0]${{'*' * (len($prefix) - 2)}}${prefix}[-1]
        END
        Log Winner          ${winner}[0]    ${anonymized_prefix}@${domain}
    END
